package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.Port_prefixContext;

public class Port_prefixContextExt extends AbstractBaseExt {

	public Port_prefixContextExt(Port_prefixContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Port_prefixContext getContext() {
		return (Port_prefixContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).port_prefix());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Port_prefixContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Port_prefixContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	/*
	 * @Override public void getMemInfo(MemInfo memInfo){ Port_prefixContext ctx =
	 * (Port_prefixContext) getContext(); if(ctx != null && ctx.children != null &&
	 * ctx.children.size()>0){
	 * memInfo.setPort_prefix(ctx.simple_identifier().extendedContext.getFormattedText()); }
	 * super.getMemInfo(memInfo); }
	 */
}
