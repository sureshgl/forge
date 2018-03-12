package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Enable_gate_instanceContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Enable_gate_instanceContextExt extends AbstractBaseExt {

	public Enable_gate_instanceContextExt(Enable_gate_instanceContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Enable_gate_instanceContext getContext() {
		return (Enable_gate_instanceContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).enable_gate_instance());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Enable_gate_instanceContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Enable_gate_instanceContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}