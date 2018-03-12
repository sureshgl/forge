package com.forge.fex.verilogprime.ext;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Input_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Input_declarationContextExt extends AbstractBaseExt {

	public Input_declarationContextExt(Input_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Input_declarationContext getContext() {
		return (Input_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).input_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Input_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Input_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void populatePorts(Map<String, ParserRuleContext> portsMap) {
		List<String> ports = new ArrayList<>();
		getPorts(ports);
		for (String port : ports) {
			portsMap.put(port, getContext());
		}
	}

	@Override
	protected void getAlteredStringForWireDeclaration(String portName, Map<String, String> table, Params params) {
		Input_declarationContext ctx = getContext();
		if (ctx.variable_port_type() != null) {
			AbstractBaseExt.L.error("Variable Port type not supported yet.");
		}
		super.getAlteredStringForWireDeclaration(portName, table, params);
	}
}