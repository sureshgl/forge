package com.forge.parser.ext;

import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Flop_arrayContext;

public class Flop_arrayContextExt extends AbstractBaseExt {

	public Flop_arrayContextExt(Flop_arrayContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Flop_arrayContext getContext() {
		return (Flop_arrayContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).flop_array());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Flop_arrayContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Flop_arrayContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		Flop_arrayContext ctx = getContext();
		String name = ctx.flop_array_identifier().extendedContext.getFormattedText();
		if (blockNames.contains(name)) {
			throw new IllegalStateException(
					"In Flop_array duplicate block with name " + name + " exists in line " + ctx.start.getLine());
		} else {
			blockNames.add(name);
		}
	}

	@Override
	public void requiredPropertyCheck() {
		Flop_arrayContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		String name = ctx.flop_array_identifier().extendedContext.getFormattedText();
		propStore.put("propName", name);
		ctx.flop_array_properties().portCap().extendedContext.getSemanticInfo(propStore);
	}
}
