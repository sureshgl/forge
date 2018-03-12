package com.forge.parser.ext;

import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.ElamContext;

public class ElamContextExt extends AbstractBaseExt {

	public ElamContextExt(ElamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ElamContext getContext() {
		return (ElamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).elam());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ElamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ElamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		ElamContext ctx = getContext();
		String name = ctx.elam_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In Elam duplicate block with name " + name + " exists in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
	}
}
