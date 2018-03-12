package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_kContext;

public class PortCap_kContextExt extends AbstractBaseExt {

	public PortCap_kContextExt(PortCap_kContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_kContext getContext() {
		return (PortCap_kContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_k());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_kContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_kContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}