package com.forge.parser.ext;

import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Property_elamContext;

public class Property_elamContextExt extends AbstractBaseExt {

	public Property_elamContextExt(Property_elamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Property_elamContext getContext() {
		return (Property_elamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).property_elam());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Property_elamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Property_elamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		Property_elamContext ctx = getContext();
		String name = ctx.property_elam_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In property_elam duplicate block with name " + name + " exists in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
	}
}
